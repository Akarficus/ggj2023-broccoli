using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    

    public GameObject mPlayerController;



    //Things that we handle in this state
    //Last PlayerCheckpoint
    //
    public Vector3 mLastCheckPoint;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
            return;
        }
        else
            Instance = this;
    }

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
