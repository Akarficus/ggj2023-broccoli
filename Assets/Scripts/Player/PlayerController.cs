using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

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

    Vector3 mHitPosition;
    bool mHitStun = false;

    //When class wakesup I need these things mapped
    private void Awake()
    {
        mMoveAction = mActions.FindActionMap( "gameplay" ).FindAction( "move" );

        mActions.FindActionMap( "gameplay" ).FindAction( "use" ).performed += OnUse;
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

        AudioManager.PlayOneShot(0, 0.75f);
        
    }

    public void PushBack(Vector3 pHitPos)
    {
        pHitPos = mHitPosition;
        mHitStun = true;
        mRidgidBody.AddForce((pHitPos - transform.position).normalized * 500);
        StartCoroutine(HitStunTime());
    }

    IEnumerator HitStunTime()
    {
        yield return new WaitForSeconds(1);
        mHitStun = false;
        mHitPosition = Vector3.zero;
    }

    //When the use key gets pressed ( prototype not sure if we will be using things )
    private void OnUse( InputAction.CallbackContext pContext )
    {
        Debug.Log( "Used the thing" );
    }


    //When the class gets enabled and disabled turn the action map on and off
    private void OnEnable()
    {
        mActions.FindActionMap( "gameplay" ).Enable();
    }

    private void OnDisable()
    {
        mActions.FindActionMap( "gameplay" ).Disable();
    }


}
