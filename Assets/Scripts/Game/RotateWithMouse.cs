using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateWithMouse : MonoBehaviour
{
    private RaycastHit mHit;
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
        Ray fRay = Camera.main.ScreenPointToRay( Input.mousePosition );

        Physics.Raycast(fRay, out mHit, 100f);
        transform.LookAt(mHit.point);
    }

}
