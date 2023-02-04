using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Audio;


public class AudioManager : MonoBehaviour
{

    static AudioManager mActivemixer = null;

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

    //default playsound, assumes position is at (0,0,0)
	static public void PlaySound(string name)
	{
		AudioManager.PlaySound (name);
	}
    static public void PlaySound(int pSound)
    {
        AudioManager.PlaySound(pSound);
    }

    static public void PlaySound(string pName, Vector3 pPos)
	{
		AudioClip fClip = null;
        //find sound clip to play
        fClip = AudioManager.mActivemixer.GetSound(pName);
        
        //find availabel audio source
        for (int i = 0; i < mActivemixer.mASource.Count; i++)
        {
            if (!mActivemixer.mASource[i].isPlaying)
            {
                mActivemixer.mASource[i].clip = fClip;
                mActivemixer.mASource[i].Play();
                return;
            }
        }
        Debug.Log("No aduiosource available");

    }
    static public void PlaySound(int pIndex, Vector3 pos)
    {
        AudioClip fClip = null;
        //get sound clip to play
        fClip = AudioManager.mActivemixer.mSounds[pIndex];

        //find available audio source
        for (int i = 0; i < mActivemixer.mASource.Count; i++)
        {
            if (!mActivemixer.mASource[i].isPlaying)
            {
                mActivemixer.mASource[i].clip = fClip;
                mActivemixer.mASource[i].Play();
                return;
            }
        }
        Debug.Log("No aduiosource available");
    }

    static public void PlayBgMusic()
    {
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
        fClip = AudioManager.mActivemixer.GetSound(pName);
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
        fClip = AudioManager.mActivemixer.mSounds[pIndex];
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
