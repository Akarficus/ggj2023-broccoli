using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    //Setting up health
    public int mCurrentHealth = 0;
    public int mMaxHealth = 100;

    public HealthBar mHealthBar;

    public GameObject mMovementController;

    // Start is called before the first frame update
    void Start()
    {
        mCurrentHealth = mMaxHealth;
    }

    // Update is called once per frame
    void Update()
    {
        IsPlayerDead();
    }

    public void DamagePlayer( int damage, Vector3 pEnemyPos)
    {
        mCurrentHealth -= damage;

        mHealthBar.SetHealth( mCurrentHealth );

        AudioManager.PlayOneShot(1,0.75f);
        mMovementController.GetComponentInChildren<PlayerController>().PushBack(pEnemyPos);
    }

    public void IsPlayerDead()
    {
        if ( mCurrentHealth <= 0 )
        {
            // go back to last checkpoint
            mMovementController.transform.position = GameManager.Instance.mLastCheckPoint;
            // reset current health back to max health
            mCurrentHealth = mMaxHealth;
            // reset health bar back to full
            mHealthBar.SetHealth(mCurrentHealth);
        }
    }

}
