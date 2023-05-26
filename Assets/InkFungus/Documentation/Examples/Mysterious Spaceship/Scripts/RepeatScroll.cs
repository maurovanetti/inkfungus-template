using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RepeatScroll : MonoBehaviour
{
    public float scrollSpeed = 5;
    public Vector3 initialPosition;
    public GameObject secondTile;
    public float repeatWidth;

    // Start is called before the first frame update
    void Start()
    {
        initialPosition = transform.position;
        repeatWidth = (secondTile.transform.position - transform.position).x;
        secondTile.transform.SetParent(transform);
    }

    // Update is called once per frame
    void Update()
    {
        transform.Translate(Vector3.left * Time.deltaTime * scrollSpeed);
        if (Mathf.Abs((transform.position - initialPosition).x) >= repeatWidth)
        {
            transform.position = initialPosition;
        }
    }

    public void setDirection(bool rightward)
    {
        if (rightward)
        {
            scrollSpeed = Mathf.Abs(scrollSpeed);
        }
        else
        {
            scrollSpeed = -Mathf.Abs(scrollSpeed);
        }
    }
}
