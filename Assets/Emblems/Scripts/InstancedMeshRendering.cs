using UnityEngine;
using UnityEditor;

[ExecuteInEditMode]
public class InstancedMeshRendering : MonoBehaviour 
{

    public int shieldIdx = 0;
    public int symbolIdx = 0;
    public int bannerIdx = 0;
    public int flagSchemeIdx = 0;
    public int primaryColorIdx = 0;
    public int secondaryColorIdx = 0;
    public int tertiaryColorIdx = 0;
    public int quartenaryColorIdx = 0;
    public int quinaryColorIdx = 0;

    MaterialPropertyBlock materialPropertyBlock;
    MeshRenderer meshRenderer;
    void Start() => SetPropertyBlock();
    
    public void SetPropertyBlock()
    {
        if (meshRenderer == null) // make it work in editor
            meshRenderer = GetComponent<MeshRenderer>();
        if (materialPropertyBlock == null)
            materialPropertyBlock = new MaterialPropertyBlock();
        
        materialPropertyBlock.SetFloat("_ShieldIndex", shieldIdx);
        materialPropertyBlock.SetFloat("_SymbolIndex", symbolIdx);
        materialPropertyBlock.SetFloat("_BannerIndex", bannerIdx);
        materialPropertyBlock.SetFloat("_FlagColorSchemeIdx", flagSchemeIdx);
        materialPropertyBlock.SetFloat("_PrimaryColorIdx", primaryColorIdx);
        materialPropertyBlock.SetFloat("_SecondaryColorIdx", secondaryColorIdx);
        materialPropertyBlock.SetFloat("_TertiaryColorIdx", tertiaryColorIdx);
        materialPropertyBlock.SetFloat("_QuartenaryColorIdx", quartenaryColorIdx);
        materialPropertyBlock.SetFloat("_QuinaryColorIdx", quinaryColorIdx);
        meshRenderer.SetPropertyBlock(materialPropertyBlock);
    }
    
}

[CustomEditor(typeof(InstancedMeshRendering))]
[CanEditMultipleObjects]
public class InstancedMeshRenderingEditor : Editor
{
    public override void OnInspectorGUI()
    {

        InstancedMeshRendering t = (InstancedMeshRendering)target;
        
        EditorGUI.BeginChangeCheck();
        t.shieldIdx = EditorGUILayout.IntSlider("Shield Index", t.shieldIdx, 0, 3);
        t.symbolIdx = EditorGUILayout.IntSlider("Symbol Index", t.symbolIdx, 0, 3);
        t.bannerIdx = EditorGUILayout.IntSlider("Banner Index", t.bannerIdx, 0, 2);
        t.flagSchemeIdx = EditorGUILayout.IntSlider("Flag Scheme Index", t.flagSchemeIdx, 0, 5);
        t.primaryColorIdx = EditorGUILayout.IntSlider("Primary Color Index", t.primaryColorIdx, 0, 31);
        t.secondaryColorIdx = EditorGUILayout.IntSlider("Secondary Color Index", t.secondaryColorIdx, 0, 31);
        t.tertiaryColorIdx = EditorGUILayout.IntSlider("Tertiary Color Index", t.tertiaryColorIdx, 0, 31);
        t.quartenaryColorIdx = EditorGUILayout.IntSlider("Quartenary Color Index", t.quartenaryColorIdx, 0, 31);
        t.quinaryColorIdx = EditorGUILayout.IntSlider("Quinary Color Index", t.quinaryColorIdx, 0, 31);

        if (EditorGUI.EndChangeCheck())
        {
            t.SetPropertyBlock();
               EditorUtility.SetDirty(t);
        }
        
    }
}





