using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenuManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayButtonPressed()
    {
        //Load Game Scene and start playing
        Debug.Log("Play Button Pressed!");
    }

    public void CreditsButtonPressed()
    {
        //Load Credit Scene and watch the credits
        Debug.Log("Credit's Button Pressed!");
    }
}
