using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WinConditionScript : MonoBehaviour
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
        Debug.Log("Player has escaped!");
        // Use a coroutine to load the Scene in the background
        //StartCoroutine(LoadWinConditionAsyncScene());
        mTransition.BeginSceneTransition();
    }

    IEnumerator LoadWinConditionAsyncScene()
    {
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync("Win");
        // Wait until the async scene fully loads
        while (!asyncLoad.isDone)
        {
            yield return null;
        }
    }
}
