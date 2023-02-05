using System.Collections;
using System.Collections.Generic;
using UnityEditor.Rendering;
using UnityEngine;

public class RotateWithMouse : MonoBehaviour
{
    public float mRadiusMax;
    public float mRadiusMin;

    private RaycastHit mHit;
    private Vector3 mLastPoint;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // tie player rotation to mouse
        //PlayerRotateMouseMovement();
        //Vector3 aimPos = GetAimPos();

        //Debug.Log("X Aim Pos:" + aimPos.x);
        // cast ray from camera to mouse position
        Ray fRay = Camera.main.ScreenPointToRay( Input.mousePosition );
        Physics.Raycast(fRay, out mHit, 100f);

        // reference: https://stackoverflow.com/questions/57593968/restricting-cursor-to-a-radius-around-my-player
        // reference: https://docs.unity3d.com/2018.3/Documentation/Manual/DirectionDistanceFromOneObjectToAnother.html
        // get vector from the player and the point of the raycast
        Vector3 fPlayerToCursor = mHit.point - transform.position;
        // normalize it to get the direction
        Vector3 fDirection = fPlayerToCursor.normalized;
        // multiply direction by the maximum radius to get a point on the radius circle around the player that is formed by this radius value
        Vector3 fCursorVectorRadiusMax = fDirection * mRadiusMax;
        //Vector3 fFinalPosMaxRadius = transform.position + fCursorVectorRadiusMax;
        // multiply direction by the minumum radius to get a point on the radius circle around the player that is formed by this radius value
        Vector3 fCursorVectorRadiusMin = fDirection * mRadiusMin;
        //Vector3 fFinalPosMinRadius = transform.position + fCursorVectorRadiusMin;

        // if the mouse cursor is within the maximum and minmum radius circles, point the flashlight at the ray cast point
        if ((fPlayerToCursor.magnitude < fCursorVectorRadiusMax.magnitude) && (fPlayerToCursor.magnitude > fCursorVectorRadiusMin.magnitude))
        {
            //Debug.Log("In Range!");
            transform.LookAt(mHit.point);
        }       
    }

}
