using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenuManager : MonoBehaviour
{
    private bool mPressedPlayButton = false;
    private bool mPressedCreditsButton = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(mPressedPlayButton)
        {
            mPressedPlayButton = false;
            SceneManager.LoadSceneAsync("Shading");
        }
        else if( mPressedCreditsButton )
        {
            mPressedCreditsButton = false;
            SceneManager.LoadSceneAsync("Credits");
        }
        
        
    }

    public void PlayButtonPressed()
    {
        //Load Game Scene and start playing
        Debug.Log("Play Button Pressed!");
        mPressedPlayButton = true;
    }

    public void CreditsButtonPressed()
    {
        //Load Credit Scene and watch the credits
        Debug.Log("Credit's Button Pressed!");
        mPressedCreditsButton = true;
    }
}
