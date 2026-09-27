using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FindEnermy : MonoBehaviour
{
    public Transform C;

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(this.transform.position, C.transform.position) <= 5) 
        {
            //第一步 算出点乘结果（方向向量）
            float dotResult = Vector3.Dot(this.transform.forward, (C.transform.position - this.transform.position).normalized);
            if (Mathf.Acos(dotResult) * Mathf.Rad2Deg <= 22.5f) 
            {
                print("发现入侵者");
            }
        }
    }
}
