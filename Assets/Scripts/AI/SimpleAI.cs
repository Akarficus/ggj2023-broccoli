using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleAI : MonoBehaviour
{
    // Start is called before the first frame update
    public int mHitDamage = 10;
    PlayerController mPlayer;
    bool mWaiting = true;
    public bool mChasePlayer = false;
    public float mMoveSpeed = 0.5f;
    public float mChaseCutOff = 10;
    float mDistanceToPlayer;
    Vector3 mPOrigin;
    Quaternion mROrigin;

    public GameObject[] mDisableObjects;

    void Start()
    {
        mPlayer = FindObjectOfType<PlayerController>();
        mPOrigin = transform.position;
        mROrigin = transform.rotation;
    }

    private void OnEnable()
    {
        StartCoroutine(IdleTime(1.5f));
    }

    // Update is called once per frame
    void Update()
    {
        if (mWaiting)
            return;

        mDistanceToPlayer = Vector3.Distance(transform.position, mPlayer.transform.position);

        if (mDistanceToPlayer >= mChaseCutOff * 2)
        { 
            mWaiting = true;
            transform.position = mPOrigin;
            transform.rotation = mROrigin;
            enabled = false;
            return; 
        }

        if (mDistanceToPlayer >= mChaseCutOff)
        {
            mChasePlayer = false;
            ToggleObjects(false);
            mPlayer.LooseEnemy(this);
        }
        else
        {
            mChasePlayer = true;
            ToggleObjects(true);
            mPlayer.SetEnemy(this);
        }

        if (mPlayer != null && mChasePlayer)
        {
            transform.LookAt(mPlayer.transform);
            transform.position = Vector3.MoveTowards(transform.position, mPlayer.transform.position, Time.deltaTime * mMoveSpeed);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "Player" && mChasePlayer)
        {
            AttackPlayer();
        }
    }

    IEnumerator IdleTime(float pWaitTime)
    {
        ToggleObjects(false);
        yield return new WaitForSeconds(pWaitTime);
        ToggleObjects(true);
        mWaiting = false;
        mChasePlayer = true;
    }

    void AttackPlayer()
    {
        mPlayer.gameObject.GetComponentInChildren<PlayerHealth>().DamagePlayer(mHitDamage,transform.position);
        mChasePlayer = false;
        mWaiting = true;
        StartCoroutine(IdleTime(1.8f));
        
    }

    void ToggleObjects(bool state)
    {
        foreach(GameObject fGO in mDisableObjects)
        {
            fGO.SetActive(state);
        }
    }
}
