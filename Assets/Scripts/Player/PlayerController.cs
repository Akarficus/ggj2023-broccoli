using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private Rigidbody mRidgidBody;
    [SerializeField] private float mSpeed = 5f;
    [SerializeField] private float mTurnSpeed = 360f;

    private Vector3 mInput;

    private Matrix4x4 mMatrix = Matrix4x4.Rotate(Quaternion.Euler(0f, 45f, 0f));


    //Assign the InputActionAsset to this field in the inspector
    public InputActionAsset mActions;

    //Private field to store and move action references
    private InputAction mMoveAction;

    private void Awake()
    {
        mMoveAction = mActions.FindActionMap( "gameplay" ).FindAction( "move" );

        mActions.FindActionMap( "gameplay" ).FindAction( "use" ).performed += OnUse;
    }

    private void Update()
    {
        //Gather Inputs
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
        mRidgidBody.MovePosition( transform.position + ( transform.forward * mInput.magnitude ) * mSpeed * Time.deltaTime );

    }


    private void OnUse( InputAction.CallbackContext pContext )
    {
        Debug.Log( "Used the thing" );
    }

    private void OnEnable()
    {
        mActions.FindActionMap( "gameplay" ).Enable();
    }

    private void OnDisable()
    {
        mActions.FindActionMap( "gameplay" ).Disable();
    }


}
