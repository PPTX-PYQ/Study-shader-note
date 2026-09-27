using System.Collections;
using System.Collections.Generic;
using UnityEditorInternal;
using UnityEngine;

public class follow : MonoBehaviour
{
    public Transform B;
    public float moveSpeed;
    private Vector3 pos;
 
    // Update is called once per frame
    void Update()
    {
        //ÏÈ¿ìºóÂý
        pos = this.transform.position;

        pos.x = Mathf.Lerp(pos.x, B.position.x, Time.deltaTime * moveSpeed);
        pos.y = Mathf.Lerp(pos.y, B.position.y, Time.deltaTime * moveSpeed);
        pos.z = Mathf.Lerp(pos.z, B.position.z, Time.deltaTime * moveSpeed);

        this.transform.position = pos;

    }
}
