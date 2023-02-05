using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AISpawner : MonoBehaviour
{
    public List<SimpleAI> mSpawnables = new List<SimpleAI>();

    void start()
    {
        foreach (SimpleAI fAI in mSpawnables)
            fAI.enabled = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
            ActiviateEntities();
    }

    void ActiviateEntities()
    {
        foreach (SimpleAI fAI in mSpawnables)
            fAI.enabled = true;
    }
}
