using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ExitCreditsScript : MonoBehaviour
{
    SceneTransitioner mTransition;

    // Start is called before the first frame update
    void Start()
    {
        mTransition = FindObjectOfType<SceneTransitioner>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("Returning to Main Menu");
        // Use a coroutine to load the Scene in the background
        //StartCoroutine(LoadMainMenuFinalAsyncScene());
        mTransition.BeginSceneTransition();
    }

    IEnumerator LoadMainMenuFinalAsyncScene()
    {
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync("Main Menu Final");
        // Wait until the async scene fully loads
        while (!asyncLoad.isDone)
        {
            yield return null;
        }
    }
}
