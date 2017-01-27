package io.nfg {
  import flash.display.Sprite;
  import away3d.library.AssetLibrary;
  import away3d.loaders.parsers.Parsers;
  import away3d.events.LoaderEvent;
  import away3d.events.AssetEvent;
  import away3d.events.ParserEvent;

  import away3d.library.assets.AssetType;
  import away3d.entities.Mesh;
  import flash.filesystem.File;
  import flash.filesystem.FileStream;
  import flash.filesystem.FileMode;
  import away3d.loaders.Loader3D;
  import flash.events.Event;
  import flash.events.InvokeEvent;
  import flash.desktop.NativeApplication;

  import flash.utils.setTimeout;


  public class Main extends Sprite {
    private var _lines:Array;
    private var _fileName:String;
    private const SOURCE_FOLDER:String = "source-awds";
    private const DEST_FOLDER:String = "dest-coffee";

    public function Main():void {
      trace('App started ...');
      trace();
      _lines = [];


      //in your init function
      Parsers.enableAllBundled();
      //AssetLibrary.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE, function(event:LoaderEvent):void { trace('loader done', event); });
      //AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function(event:LoaderEvent):void { trace('loader done2', event); });
      //AssetLibrary.addEventListener(ParserEvent.PARSE_COMPLETE, function(event:ParserEvent):void { trace('parser done'); });

      // Step 1: list all awds files to export
      var importFolder:File = File.applicationDirectory.resolvePath(SOURCE_FOLDER);
      var awdFileNames:Array = [];
      var files:Array = importFolder.getDirectoryListing();
      trace('AWD file to export:');
      trace('-------------------');
      for (var i:uint = 0; i < files.length; i++) {
        if(files[i].name.indexOf('.awd') > -1) {
          //trace(files[i].nativePath); // gets the path of the files
          trace("  - " + files[i].name);// gets the name
          awdFileNames.push(files[i].name);
        }
      }
      trace();

      // Step 3: for each asset loaded in the awd -> fill this._lines
      //AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
      AssetLibrary.addEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete);

      // Step 4: export this._lines to target.coffee, if awdFiles.length > 0 then parse next else quit app
      AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function(event:LoaderEvent):void {
        _writeFile(_fileName.replace('.awd', '.coffee'),"module.exports = [\n" + _lines.join(",\n") + "\n]");
        if(awdFileNames.length > 0) {
          _fileName = awdFileNames.shift();
          _readFile();
        } else {
          trace();
          trace('... Quitting');
          NativeApplication.nativeApplication.exit();
        }
      });

      // Step 2: read first file of the folder
      this._fileName = awdFileNames.shift();
      _readFile();

    }

    private function _readFile():void {
      var testFile:File = File.applicationDirectory.resolvePath(SOURCE_FOLDER).resolvePath(_fileName); // Point it to an actual file
      testFile.load();
      testFile.addEventListener(Event.COMPLETE, function(e:Event):void {
        var loader:Loader3D = new Loader3D();

        loader.loadData(testFile.data);
        /*
        loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function(e:LoaderEvent):void {
          trace(e);
        });
        */
      });
    }

    private function _writeFile(fileName, text:String):void {
      trace('> Saving ' + fileName);
      var pathToFile:String = File.applicationDirectory.resolvePath(DEST_FOLDER + '/' + fileName).nativePath;
      var file:File = new File(pathToFile);
      var stream:FileStream = new FileStream();
      stream.open(file, FileMode.WRITE);
      stream.writeUTFBytes(text);
      stream.close();
    }

    //separate function
    private function onAssetComplete(event:AssetEvent):void {
      //trace()
      //trace(event.asset.assetType);
      //if (event.asset.assetType == AssetType.MESH) {
        var m:Mesh = event.asset as Mesh;
        var line:String;
        line = "  "
        //line += "{ model: \"" + m.name.split('.')[0] + "\", ";
        line += "{ model: \"" + m.name.split(' ')[0].replace('graveyard-', '') + "\", ";
        line += "x: " + m.x + ", y: " + m.y + ", z: " + m.z + ", ";
        line += "rx: " + m.rotationX + ", ry: " + m.rotationY + ", rz: " + m.rotationZ + ", ";
        line += "sx: " + m.scaleX + ", sy: " + m.scaleY + ", sz: " + m.scaleZ + " ";
        line += "}"
        _lines.push(line)
        //trace("  ", event.asset.name, [m.x, m.y, m.z], [m.rotationX, m.rotationY, m.rotationZ], [m.scaleX, m.scaleY, m.scaleZ]);
        //var m:Mesh = new Mesh ( m.geometry, m.material);
        //m.geometry.scale(7);
        //view.scene.addChild(m);
      //}
      /*
      } else if (event.asset.assetType == AssetType.MESH) {
        trace(event.asset.name);
      } else if (event.asset.assetType == AssetType.TEXTURE) {
        trace(event.asset.name);
      } else if (event.asset.assetType == AssetType.GEOMETRY) {
        trace(event.asset.name);
      } */
    }
  }
}
