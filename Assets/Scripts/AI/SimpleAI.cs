using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleAI : MonoBehaviour
{
    // Start is called before the first frame update
    PlayerController mPlayer;
    public float mMoveSpeed = 0.5f;

    void Start()
    {
        mPlayer = FindObjectOfType<PlayerController>();
    }

    // Update is called once per frame
    void Update()
    {
        if (mPlayer != null)
        {
            transform.LookAt(mPlayer.transform);
            transform.position = Vector3.MoveTowards(transform.position, mPlayer.transform.position, Time.deltaTime * mMoveSpeed);
        }
    }
}
