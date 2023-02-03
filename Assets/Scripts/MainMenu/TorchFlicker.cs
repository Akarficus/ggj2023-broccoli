using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TorchFlicker : MonoBehaviour
{
    //variables
    public Light mLight;
    public float mMinIntensity = 0f;
    public float mMaxIntensity = 1f;

    [Tooltip("How much to smooth out the randomness; lower values= sparks, higher = latern")]
    [Range(1, 50)]
    public int mSmoothing = 5;


    Queue<float> mSmoothQueue;
    float mLastSum = 0f;

    public void Reset()
    {
        mSmoothQueue.Clear();
        mLastSum = 0f;
    }

    private void Start()
    {
        mSmoothQueue = new Queue<float>(mSmoothing);

        //External or Internal Light?
        if (mLight == null)
        {
            mLight = GetComponent<Light>();
        }
    }

    private void Update()
    {
        //Pop off an item if it is too big
        while (mSmoothQueue.Count >= mSmoothing)
        {
            mLastSum -= mSmoothQueue.Dequeue();
        }

        //Generate random new item, calculate new average
        float fNewVal = Random.Range(mMinIntensity, mMaxIntensity);
        mSmoothQueue.Enqueue(fNewVal);
        mLastSum += fNewVal;

        //Calculate new smoothed average
        mLight.intensity = mLastSum / (float)mSmoothQueue.Count;
    }
}

