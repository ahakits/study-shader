using UnityEngine;

namespace Sample
{
    public class Sample09 : MonoBehaviour
    {
        [SerializeField]
        private GameObject targetA;

        [SerializeField]
        private GameObject targetB;

        private Renderer rendererA;

        private Renderer rendererB;

        private MaterialPropertyBlock materialPropertyBlock;

        void Start()
        {
            materialPropertyBlock = new MaterialPropertyBlock();
            materialPropertyBlock.SetFloat("_FloatValue", Random.value);

            var materials = FindObjectsOfType<Material>();
            Debug.Log("MATERIAL_COUNT_IN_SCENE :" + materials.Length);

            foreach (var material in materials)
            {
                Debug.Log(material.name);
            }

            rendererA = targetA.GetComponent<Renderer>();
            rendererB = targetB.GetComponent<Renderer>();
            rendererB.SetPropertyBlock(materialPropertyBlock);
        }

        void Update()
        {
            rendererA.material.SetFloat("_FloatValue", Random.value);
        }
    }
}
