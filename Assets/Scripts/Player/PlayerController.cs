using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
//using UnityEditor.SearchService;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class PlayerController : MonoBehaviour
{


    //Some kind of component that takes health ? Can we heal?

    //Do we see the healthbar?
    //Should it be here or in a different component?


    //Physics body information
    [SerializeField] private Rigidbody mRidgidBody;
    [SerializeField] private float mSpeed = 5f;
    [SerializeField] private float mTurnSpeed = 360f;

    //Controller input calculations (ISO movement calcs)
    private Vector3 mInput;

    private Matrix4x4 mMatrix = Matrix4x4.Rotate(Quaternion.Euler(0f, 45f, 0f));


    //Assign the InputActionAsset to this field in the inspector
    public InputActionAsset mActions;

    //Private field to store and move action references
    private InputAction mMoveAction;

    public float mStepCycle = 0f;
    float mNextStep = 6f;

    bool mHitStun = false;
    List<SimpleAI> mChasingEnemies = new List<SimpleAI>();
    bool mBeingChased = false;

    //When class wakesup I need these things mapped
    private void Awake()
    {
        // Return the current Active Scene in order to get the current Scene name.
        UnityEngine.SceneManagement.Scene fScene = SceneManager.GetActiveScene();
        if (fScene.name == "Credits")
        {
            mMoveAction = mActions.FindActionMap("credits").FindAction("move");

            mActions.FindActionMap("credits").FindAction("use").performed += OnUse;
        }
        else
        {
            mMoveAction = mActions.FindActionMap("gameplay").FindAction("move");

            mActions.FindActionMap("gameplay").FindAction("use").performed += OnUse;
        }
    }

    private void Update()
    {
        //Gather Inputs
        if (mHitStun)
            return;

        Vector2 fMoveVector = mMoveAction.ReadValue<Vector2>();
        mInput = new Vector3( fMoveVector.x, 0f, fMoveVector.y );

        //Look Realtive transform position but only if we are turning
        if( mInput != Vector3.zero )
        {
            //New skew rotation calculation multiplying it by the
            var fSkewedRotation = mMatrix.MultiplyPoint3x4( mInput );

            //Determining the direction to go
            var fRelative = ( transform.position + fSkewedRotation ) - transform.position;
            var fRot = Quaternion.LookRotation( fRelative, Vector3.up );

            //Add some lerp
            transform.rotation = Quaternion.RotateTowards( transform.rotation, fRot, mTurnSpeed * Time.deltaTime );
            //transform.rotation = fRot;
        }  
    }

    private void FixedUpdate()
    {
        //Move only when the mInput magnitude is being pushed or non 0
        if (!mHitStun)
        {
            mRidgidBody.MovePosition(transform.position + (transform.forward * mInput.magnitude) * mSpeed * Time.deltaTime);
            ProgressStepCycle();
        }
    }

    private void ProgressStepCycle()
    {
        if (mInput.sqrMagnitude > 0)
        {
            mStepCycle += (mInput.magnitude + mSpeed) *Time.fixedDeltaTime;
        }

        if (mStepCycle < mNextStep)
        {
            return;
        }

        mStepCycle = 0f;
        AudioManager.PlayOneShot(0, 0.70f);       
    }

    public void SetEnemy(SimpleAI pEnemy)
    {
        if (mChasingEnemies.Count == 0)
        {
            mBeingChased = true;
            AudioManager.PlayBgMusic(1);
        }
        if(!mChasingEnemies.Contains(pEnemy))
            mChasingEnemies.Add(pEnemy);
    }
    public void LooseEnemy(SimpleAI pEnemy)
    {
        if(mChasingEnemies.Contains(pEnemy))
            mChasingEnemies.Remove(pEnemy);
        if (mChasingEnemies.Count == 0 && mBeingChased)
        {
            AudioManager.PlayBgMusic(0);
            mBeingChased = false;
        }
    }

    public void PushBack(Vector3 pHitPos)
    {
        mHitStun = true;
        mRidgidBody.AddForce((transform.position - pHitPos) * 3000);
        StartCoroutine(HitStunTime());
    }

    IEnumerator HitStunTime()
    {
        yield return new WaitForSeconds(1);
        mHitStun = false;
    }

    //When the use key gets pressed ( prototype not sure if we will be using things )
    private void OnUse( InputAction.CallbackContext pContext )
    {
        Debug.Log( "Used the thing" );
    }


    //When the class gets enabled and disabled turn the action map on and off
    private void OnEnable()
    {
        // Return the current Active Scene in order to get the current Scene name.
        UnityEngine.SceneManagement.Scene fScene = SceneManager.GetActiveScene();
        if (fScene.name == "Credits")
        {
            mActions.FindActionMap("credits").Enable();
        }
        else
        {
            mActions.FindActionMap("gameplay").Enable();
        }
    }

    private void OnDisable()
    {
        // Return the current Active Scene in order to get the current Scene name.
        UnityEngine.SceneManagement.Scene fScene = SceneManager.GetActiveScene();
        if (fScene.name == "Credits")
        {
            mActions.FindActionMap("credits").Disable();
        }
        else
        {
            mActions.FindActionMap("gameplay").Disable();
        }
    }


}
