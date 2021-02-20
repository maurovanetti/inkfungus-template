using UnityEngine;
using UnityEditor;

namespace InkFungus
{
    class MenuItemsCreator
    {
        private static GameObject SpawnPrefab(string prefabName)
        {
            GameObject prefab = Resources.Load<GameObject>("Prefabs/" + prefabName);
            if (prefab == null)
            {
                Debug.LogError("Prefab " + prefabName + " not found");
            }
            GameObject go = GameObject.Instantiate(prefab) as GameObject;
            go.name = prefab.name;
            go.transform.position = Vector3.zero;
            Selection.activeGameObject = go;
            Undo.RegisterCreatedObjectUndo(go, "Create Object");
            return go;
        }

        [MenuItem("Tools/Fungus/Create/Ink-Fungus Gateway", false, 100000)]
        static void CreateInkFungusGateway()
        {
            SpawnPrefab("Ink-Fungus Gateway");
        }

        [MenuItem("Tools/Fungus/Create/Variable Processor", false, 100000)]
        static void CreateVariableProcessor()
        {
            SpawnPrefab("Variable Processor");
        }
    }
}
