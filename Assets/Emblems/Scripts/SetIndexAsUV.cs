using UnityEngine;
using UnityEngine.UI;
public class SetIndexAsUV : BaseMeshEffect
{
    [Range(0, 3)]
    public int shieldIdx = 0;
    [Range(0, 3)]
    public int symbolIdx = 0;
    [Range(0, 2)]
    public int bannerIdx = 0;
    [Range(0, 5)]
    public int flagSchemeIdx = 0;

    [Range(0, 31)]
    public int primaryColorIdx = 0;
    [Range(0, 31)]
    public int secondaryColorIdx = 0;
    [Range(0, 31)]
    public int tertiaryColorIdx = 0;
    [Range(0, 31)]
    public int quartenaryColorIdx = 0;
    [Range(0, 31)]
    public int quinaryColorIdx = 0;
    protected SetIndexAsUV(){}

    public override void ModifyMesh(VertexHelper vh)
    {
        UIVertex vert = new UIVertex();
        for (int i = 0; i < vh.currentVertCount; i++)
        {
            vh.PopulateUIVertex(ref vert, i);
            vert.uv0 = new Vector3(vert.uv0.x, vert.uv0.y, quinaryColorIdx);
            vert.uv1 = new Vector4(primaryColorIdx, secondaryColorIdx, tertiaryColorIdx, quartenaryColorIdx);
            vert.uv2 = new Vector4(shieldIdx, symbolIdx, bannerIdx, flagSchemeIdx);
            vh.SetUIVertex(vert, i);
        }
    }
}





