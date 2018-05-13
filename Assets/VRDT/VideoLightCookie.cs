/**
 * Allows you to use a video as a cookie on a projector.
 */

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VideoLightCookie : MonoBehaviour {


    public MovieTexture movie;

    private Projector projector;

	// Use this for initialization
	void Start () {
        projector = GetComponent<Projector>();
        projector.material.SetTexture("_ShadowTex", movie);
        movie.loop = true;
        movie.Play();
	}
	
}
