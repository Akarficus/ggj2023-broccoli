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
    }

    public void DamagePlayer( int damage )
    {
        mCurrentHealth -= damage;

         mHealthBar.SetHealth( mCurrentHealth );
    }

}
