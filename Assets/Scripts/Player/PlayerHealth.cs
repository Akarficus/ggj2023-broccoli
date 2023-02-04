using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    //Setting up health
    public int mCurrentHealth = 0;
    public int mMaxHealth = 100;

    public HealthBar mHealthBar;



    // Start is called before the first frame update
    void Start()
    {
        mCurrentHealth = mMaxHealth;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown( KeyCode.Space ) )
        {
            DamagePlayer( 10 );
        }
        // check to see if player is dead
        IsPlayerDead();
    }

    public void DamagePlayer( int damage )
    {
        mCurrentHealth -= damage;

        mHealthBar.SetHealth( mCurrentHealth );
    }

    public void IsPlayerDead()
    {
        if ( mCurrentHealth <= 0 )
        {
            // go back to last checkpoint
            transform.position = GameManager.Instance.mLastCheckPoint;
            // reset current health back to max health
            mCurrentHealth = mMaxHealth;
            // reset health bar back to full
            mHealthBar.SetHealth(mCurrentHealth);
        }
    }

}