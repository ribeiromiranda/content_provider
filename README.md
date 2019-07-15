a flutter plugin for providing similar feature like content provider in android.

<b>features</b>:<br>
1)Retrive data <br>
2)insert data <br>
3)update data <br>
4)remove data <br>

<b>plugin methods to call </b>:

<b> 1)retrive data:</b>-<br>ContentProviderPlugin.getContentValue(String uri)<br>
uri:-Simply pass uri of data you want to get<br>
<b>2)insert data:</b>-<br>ContentProviderPlugin.insertContentValue(String uri, dynamic data)<br>
uri:-Simply pass uri of where you want to insert data<br>
data:-second parameter data is the data you want to insert<br>
<b>3)update data:</b>-<br>ContentProviderPlugin.updateContentValue(String uri, dynamic data,{String where, List<String> whereArgs})<br>
uri:-Simply pass uri of where you want to update data<br>
data:-second parameter data is the data you want to update<br>
optional param:-<br>
where,whereargs
<b><br>4)remove data:</b> <br>deleteContentValue(String uri, dynamic data, String where,
      List<String> selectionArgs
 uri:-Simply pass uri of where you want to remove data<br>
data:-second parameter data is the data you want to remove<br>  
  
<b>Example</b>:-<link>https://github.com/deep-stl/content_provider/tree/master/example/lib</link>

<b>Permissions</b>:-Permissions are not handle by plugin.users need to handle run time permission.
