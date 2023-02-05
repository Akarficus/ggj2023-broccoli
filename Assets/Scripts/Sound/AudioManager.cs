using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Audio;


public class AudioManager : MonoBehaviour
{

    public static AudioManager mActivemixer = null;

    public AudioClip[] mBGSounds;//list of all background sounds/music
    public AudioClip[] mSounds;//list of all sounds that can be played
    public AudioSource mBGSource;
    public AudioSource mAudioSource;//one shot audio source
    public AudioMixer mAudioMixer;
    public int mNumchannels = 16;
    public List<AudioSource> mASource = new List<AudioSource>();


    void Start()
    {
        if (mActivemixer == null)
        {
            mActivemixer = this;
            if (mAudioSource == null)
                mAudioSource = FindObjectOfType<AudioSource>();
            if (mBGSource == null)
                mBGSource = mAudioSource;
            for (int i = 0; i < mNumchannels; i++)
            {
                GameObject go = (GameObject)Instantiate(Resources.Load("AudioSource"));
                go.transform.parent = transform;
                mASource.Add(go.GetComponent<AudioSource>());
            }
            DontDestroyOnLoad(gameObject);
        }
        mBGSource.clip = mBGSounds[0];
    }

    static public void PlayBgMusic(int pMusic)
    {
        AudioClip fClip = mActivemixer.mBGSounds[pMusic];
        if (mActivemixer.mBGSource.clip == fClip && mActivemixer.mBGSource.isPlaying)
            return;

        mActivemixer.mBGSource.clip = fClip;
        mActivemixer.mBGSource.Play();
    }
    static public void StopBgMusic()
    {
        mActivemixer.mBGSource.Stop();
    }



    static public void PlayOneShot(string pName, float pVolume)
    {
        AudioClip fClip = null;
        //find sound clip to play
        fClip = mActivemixer.GetSound(pName);
        if (!mActivemixer.mAudioSource.isPlaying)
        {
            mActivemixer.mAudioSource.clip = fClip;
            mActivemixer.mAudioSource.PlayOneShot(fClip,pVolume);
        }
    }
    static public void PlayOneShot(int pIndex, float pVolume)
    {
        AudioClip fClip = null;
        //find sound clip to play
        fClip = mActivemixer.mSounds[pIndex];
        if (!mActivemixer.mAudioSource.isPlaying)
        {
            mActivemixer.mAudioSource.clip = fClip;
            mActivemixer.mAudioSource.PlayOneShot(fClip, pVolume);
        }
    }

    AudioClip GetSound(string pName)
    {
        AudioClip fClip = null;
        for (int i = 0; i < mActivemixer.mSounds.Length; i++)
        {
            if (mActivemixer.mSounds[i].name == pName)
            {
                fClip = mActivemixer.mSounds[i];
                break;
            }
        }
        if (fClip == null)
        {
            Debug.Log("Error: Sound: " + pName + " ; not found");
            return fClip;
        }
        else
            return fClip;
    }

    static public void ChangeMixerVolume(int pMixer, float pNewVolume)
    {
        if(pMixer == 1)
        {
            mActivemixer.mAudioMixer.SetFloat("SfxVol", pNewVolume);
        }
        if(pMixer == 2)
        {
            mActivemixer.mAudioMixer.SetFloat("MusicVol", pNewVolume);
        }
        if(pMixer == 0)
        {
            mActivemixer.mAudioMixer.SetFloat("MasterVol", pNewVolume);
        }
    }
}
