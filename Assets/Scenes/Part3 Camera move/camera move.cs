using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameramove : MonoBehaviour
{
    public Transform target;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        //摄像机的位置等于目标的位置进行向量偏移
        //先朝目标对象的 面朝向的反方向平移4米 再朝目标的头顶位置平移七米
        this.transform.position = target.position + -target.forward * 4 + target.up * 7;

        this.transform.LookAt(target);
    }
}
