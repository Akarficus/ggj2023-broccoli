using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SceneTransitioner : MonoBehaviour
{

    public Canvas mTransitionCanvas;
    public Animator mTransitionAnimator;
    public string mNextScene;
    public GameObject mFadePanel;
    bool mFadingIn = false;

    private void Start()
    {
        if (mFadePanel.activeSelf)
            EndSceneTransition();
    }

    public void BeginSceneTransition()
    {
        mFadingIn = true;
        mFadePanel.SetActive(true);
        mTransitionAnimator.SetBool("FadeScreen", true);
        
    }

    //called when the animation for fading ends, either fading in or out
    public void OnEndFading()
    {
        if(mFadingIn)
            ChangeScene();
        else
            mFadePanel.SetActive(false);
    }


    public void EndSceneTransition()
    {
        mFadingIn = false;
        mTransitionAnimator.SetBool("FadeScreen", false);
    }
    void ChangeScene()
    {
        StartCoroutine(SceneWait());
    }

    IEnumerator SceneWait()
    {
        yield return new WaitForSeconds(1);
        SceneManager.LoadSceneAsync(mNextScene);
    }
    public void ChangeLoadingScene(string pSceneName)
    {
        mNextScene = pSceneName;
        BeginSceneTransition();
    }
}
