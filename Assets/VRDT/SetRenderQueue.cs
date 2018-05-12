/* This script comes from a Unity engineer via this forum post: https://forum.unity.com/threads/depth-sort-alpha-issues-way-to-override.29893/#post-195242 */


using UnityEngine;
using System.Collections;

[AddComponentMenu("Effects/SetRenderQueue")]
[RequireComponent(typeof(Renderer))]

public class SetRenderQueue : MonoBehaviour
{
    public int queue = 1;

    public int[] queues;

    protected void Start()
    {
        var rend = GetComponent<Renderer>();

        if (!rend || !rend.sharedMaterial || queues == null)
            return;
        rend.sharedMaterial.renderQueue = queue;
        for (int i = 0; i < queues.Length && i < rend.sharedMaterials.Length; i++)
            rend.sharedMaterials[i].renderQueue = queues[i];
    }

}