using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreditsManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // exit the game
        if (Input.GetKeyDown(KeyCode.Escape) && Application.platform == RuntimePlatform.WindowsPlayer)
        {
            Application.Quit();
        }
    }
}
