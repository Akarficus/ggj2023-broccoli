using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenuManager : MonoBehaviour
{
    // Show font outline
    [SerializeField] Material playFontMaterial = null;
    [SerializeField] Material creditFontMaterial = null;

    private bool mPressedPlayButton = false;
    private bool mPressedCreditsButton = false;

    // Start is called before the first frame update
    void Start()
    {
        // Disable outline
        playFontMaterial.DisableKeyword("OUTLINE_ON");
        creditFontMaterial.DisableKeyword("OUTLINE_ON");
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
        // exit the game
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }
        
    }

    public void PlayButtonPressed()
    {
        //Load Game Scene and start playing
        Debug.Log("Play Button Pressed!");
        mPressedPlayButton = true;


        // to feel of pushing
        playFontMaterial.EnableKeyword("OUTLINE_ON");
        playFontMaterial.SetColor("_OutlineColor", new Color(1, 1, 1, 1));
    }

    public void CreditsButtonPressed()
    {
        //Load Credit Scene and watch the credits
        Debug.Log("Credit's Button Pressed!");
        mPressedCreditsButton = true;

        // to feel of pushing.Added by:Siraph
        creditFontMaterial.EnableKeyword("OUTLINE_ON");
        creditFontMaterial.SetColor("_OutlineColor", new Color(1, 1, 1, 1));
    }
}
