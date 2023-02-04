using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour
{
    public RectTransform mHealthBarImage;

    public void SetHealth( int pHealthAmount )
    {
        //Update the canvas and its children
        Canvas.ForceUpdateCanvases();
        //Update the health amount as if we were going from 0 to 1 where 0 represents full health an 1 represents no health
        if (pHealthAmount < 0)
            pHealthAmount = 0;

        // 90/100 = 0.9 - 1f * -1;
        float fHealth = ( ( ( float ) pHealthAmount / 100f ) - 1f ) * -1;
        mHealthBarImage.offsetMin = new Vector2(mHealthBarImage.offsetMin.x, fHealth);
                                    //( ( float ) pHealthAmount / 100f ) - 1f;
    }
}
