using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThrowTorch : MonoBehaviour
{
	float forceRotation = 10f;
	bool hitGround = false;
	private void Start()
	{
		Vector3 forceDirection = new (-3.5f, 3.0f, 0f);

		float forceMagnitude = 2.0f;

		// calculate force
		Vector3 force = forceMagnitude * forceDirection;

		Rigidbody rb = gameObject.GetComponent<Rigidbody>();

		rb.AddForce(force, ForceMode.Impulse);
	}

    private void FixedUpdate()
    {
		if (!hitGround)
		{
			transform.Rotate(new Vector3(forceRotation, 0f, -3.5f));
			forceRotation -= 0.05f;
		}
		else
			forceRotation = 0f;
    }

    private void OnCollisionEnter(Collision collision)
    {
		hitGround = true;
    }
}
