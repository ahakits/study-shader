using UnityEngine;

namespace Sample
{
    [ExecuteInEditMode]
    public class Sample08 : MonoBehaviour
    {
        [SerializeField]
        private Material material;

        [SerializeField]
        [Range(0, 1)]
        private float floatValue;

        private int floatValueId;

        [SerializeField]
        private Color globalColorValue;

        private int globalColorValueId;

        void Start()
        {
            floatValueId = Shader.PropertyToID("_FloatValue");
            globalColorValueId = Shader.PropertyToID("_GlobalColorValue");
        }

        void Update()
        {
            material.SetFloat(floatValueId, floatValue);
            Shader.SetGlobalColor(globalColorValueId, globalColorValue);
        }
    }
}
