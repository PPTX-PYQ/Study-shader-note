using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FindEnermy2 : MonoBehaviour
{
    public Transform A;
    public Transform C;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //判断前后
        if(Vector3.Dot(A.forward, C.position - A.position)>=0 )
        {
            //右侧
            if(Vector3 .Cross(A.forward,C.position - A.position).y >= 0)
            {
                print("右前");
            }
            else
            {
                print("左前");
            }
        }
        else
        {
            //右侧
            if (Vector3.Cross(A.forward, C.position - A.position).y >= 0)
            {
                print("右后");
            }
            else
            {
                print("左后");
            }
        }
    }
}
