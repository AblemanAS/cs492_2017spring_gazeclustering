using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public class DistributeInputData : MonoBehaviour {
    public float   dataFrameTime   =   0.0f;

    GameObject      data;
    string          line;
    FileStream      fileStream;
    StreamReader    streamReader;
    List<string>    list;
    int             clusterIdx      =   1;
    int             dataIdx         =   1;
    string[]        dataLabel       =   null;
    GameObject[]    lineObject      = new GameObject[800];
    LineRenderer[]  newLine         = new LineRenderer[800];

    IEnumerator MeanClustering()
    {
        fileStream = new FileStream(@"C:\UnityApp\IUI_Gaze_Visual\means4.txt", FileMode.Open, FileAccess.Read);
        streamReader = new StreamReader(fileStream, Encoding.UTF8);
        list = new List<string>();

        float xPos, yPos;
        Vector3 dataPos;

        while ((line = streamReader.ReadLine()) != null)
        {
            data = GameObject.Find("cluster" + clusterIdx);
            list.Add(line);
            string[] dataNum = line.Split(' ');

            for (int i = 0; i < dataNum.Length; i += 2)
            {
                xPos = 0.1f * float.Parse(dataNum[i]);
                yPos = 0.1f * float.Parse(dataNum[i + 1]);
                dataPos = new Vector3(xPos, yPos, 0);

                GameObject newData = Instantiate(data, data.transform.parent);
                newData.name = clusterIdx + ", cluster_" + dataIdx;
                newData.transform.position = dataPos;
                dataIdx++;
                yield return new WaitForSeconds(dataFrameTime);
            }
            dataIdx = 0;
            clusterIdx++;
        }

    }
    IEnumerator ParticipantVisual()
    {
        float xPos, yPos;
        Vector3 dataPos;
        Vector3 beforePos = Vector3.zero;
        int labelIdx = 0;
        int lineIdx = 0;
        dataIdx = 1;
        clusterIdx = 1;

        fileStream = new FileStream(@"C:\UnityApp\IUI_Gaze_Visual\data4.txt", FileMode.Open, FileAccess.Read);
        streamReader = new StreamReader(fileStream, Encoding.UTF8);
        list = new List<string>();

        while ((line = streamReader.ReadLine()) != null)
        {
            //line 52줄 각 속하는 cluster 가지고있음.
            list.Add(line);
            string[] dataNum = line.Split(' ');

            //line의 첫번째에 cluster idx를 가지고 있다고 가정.
            data = GameObject.Find("data" + dataLabel[labelIdx]);  // dataLabe[labelIdx] : 0, 1, 2, 3  , labelIdx증가 필요.

            for (int i = 0; i < dataNum.Length; i += 2)
            {
                xPos = 0.1f * float.Parse(dataNum[i]);
                yPos = 0.1f * float.Parse(dataNum[i + 1]);
                dataPos = new Vector3(xPos, yPos, 0);

                GameObject newData = Instantiate(data, data.transform.parent);
                newData.name = labelIdx + ", data_" + dataIdx;
                newData.transform.position = dataPos;
                dataIdx++;

               /* if (beforePos == Vector3.zero)
                    beforePos = newData.transform.position;
                else
                {
                    beforePos = newData.transform.position;
                    newLine[lineIdx].SetPosition(0, beforePos);
                    newLine[lineIdx].SetPosition(1, newData.transform.position);
                }
                lineIdx++;*/

                yield return new WaitForSeconds(dataFrameTime);
            }
            dataIdx = 0;
            labelIdx++;

            if(labelIdx == 2) break;
        }
    }
    void Start () {
        //StartCoroutine(MeanClustering());

        //Line Object 생성. & Set
       /* for (int i = 0; i < newLine.Length; i++)
        {
            //lineObject[i] = new GameObject();

            newLine[i] = GetComponent<LineRenderer>();//lineObject[i].AddComponent<LineRenderer>();

            newLine[i].startWidth = 0.1f;
            newLine[i].endWidth = 0.1f;
        }*/

        //Participant Labeling 준비.
        fileStream          = new FileStream(@"C:\UnityApp\IUI_Gaze_Visual\datalabel4.txt", FileMode.Open, FileAccess.Read);
        streamReader        = new StreamReader(fileStream, Encoding.UTF8);
        list                = new List<string>();

        while ((line = streamReader.ReadLine()) != null)
        {
            list.Add(line);
            dataLabel = line.Split(' ');
        }
        /////////////////////////////////////////////////


        StartCoroutine(ParticipantVisual());


    }

}
