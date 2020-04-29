using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IMove : MonoBehaviour
{
    public bool canMove1;
    public bool canMove2;
    public bool canMove3;
    IEnumerator Move()
    {
        transform.position += new Vector3(10, 0, 0);
        while (canMove1)
            yield return null;
        
        transform.position += new Vector3(10, 0, 0);
        while (canMove2)
            yield return null;

        transform.position += new Vector3(10, 0, 0);
        while (canMove3)
            yield return null;
    }

    private void Start()
    {
        IEnumerator e = Move();
        while (e.MoveNext())
        {
            Debug.Log("Move Done");
        }
    }
}
