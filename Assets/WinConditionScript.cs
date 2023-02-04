using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WinConditionScript : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("Player has escaped!");
        // Use a coroutine to load the Scene in the background
        StartCoroutine(LoadWinConditionAsyncScene());
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
