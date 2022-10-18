/*****************************************************************************/
/* ShoeBox Tools                                                             */
/* support@project-jack.com                                                  */
/*                                                                           */
/* Module Description:                                                       */
/*                                                                           */
/* Imports XML sprite sheets exported by ShoeBox.                            */
/*                                                                           */
/* Copyright © 2015 project|JACK, LLC                                        */
/*****************************************************************************/

						   /* MODIFICATION LOG */
/*****************************************************************************/
/*  Date     * Who     * Comment                                             */
/*---------------------------------------------------------------------------*/
/*  4/23/15  * Austin  * Created                                             */
/*****************************************************************************/

using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using System.Collections.Generic;

public class SBT_SpriteSheet
{
	private static string directory = "";

	[ MenuItem("Assets/ShoeBox Tools/Import Sprite Sheet") ]
	public static void Init()
	{
		string path = EditorUtility.OpenFilePanel( "Import ShoeBox Sprite Sheet", directory, "xml" );

		if ( !string.IsNullOrEmpty( path ) )
		{
			directory = Path.GetDirectoryName( path );
			Import( Path.GetFullPath( path ) );
		}
	}

	static void Import( string path )
	{
		XElement root = XElement.Load( path );

		// find and load the sprite sheet texture
		string assetPath = LoadSpriteTexture( root );

		Texture2D texture = AssetDatabase.LoadAssetAtPath( assetPath, typeof(Texture2D) ) as Texture2D;

		// parse and compute the sprite sheet data
		List<SpriteMetaData> sheet = ParseSprites( root, texture.height );

		// apply sprite sheet data to imported texture
		SaveSpriteSheet( sheet, texture );
	}

	static List<SpriteMetaData> ParseSprites( XElement xml, int texH )
	{
		List<SpriteMetaData> data = new List<SpriteMetaData>();

		IEnumerable<XElement> elements = xml.Elements( "SubTexture" );

		foreach( XElement e in elements )
		{
			Rect r = new Rect();
			r.width = (float) e.Attribute( "width" );
			r.height = (float) e.Attribute( "height" );
			r.x = (float) e.Attribute( "x" );
			r.y = (float) texH - (float) e.Attribute( "y" ) - r.height;

			SpriteMetaData sprite = new SpriteMetaData();
			sprite.rect = r;
			sprite.name = e.Attribute( "name" ).Value;
			sprite.name = Path.GetFileNameWithoutExtension( sprite.name );

			data.Add( sprite );
		}

		return data;
	}

	static string LoadSpriteTexture( XElement xml )
	{
		string path = directory + Path.DirectorySeparatorChar + xml.Attribute( "imagePath" ).Value;
		path = Path.GetFullPath( path );

		if ( string.IsNullOrEmpty( path ) )
		{
			Debug.LogError( "Invalid Sprite Sheet Import Path" );
			return null;
		}

		string name = Path.GetFileName( path );
		string destPath = Application.dataPath + "/" + name;
		string assetPath = "Assets/" + name;

		File.Copy( path, destPath );
		AssetDatabase.Refresh();

		return assetPath;
	}

	static void SaveSpriteSheet( List<SpriteMetaData> sheet, Texture2D texture )
	{
		string path = AssetDatabase.GetAssetPath( texture );
		
		TextureImporter importer = AssetImporter.GetAtPath( path ) as TextureImporter;
		importer.spritesheet = sheet.ToArray();
		importer.textureType = TextureImporterType.Sprite;

		TextureImporterSettings settings = new TextureImporterSettings();
		importer.ReadTextureSettings( settings );
		settings.textureFormat = TextureImporterFormat.AutomaticTruecolor;
		settings.mipmapEnabled = false;
		settings.spriteMode = (int) SpriteImportMode.Multiple;
		importer.SetTextureSettings( settings );

		AssetDatabase.ImportAsset( path, ImportAssetOptions.ForceUpdate );
	}
}