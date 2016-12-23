<?php
$uri = "mongodb://".$_SERVER['MONGODB_SERVICE_SERVICE_HOST'];
$categories = array( "Physical Servers","Virtual Servers","Network Device");
$i=1;
foreach($categories as $category) {
  $data[] = array( "_id" => $i, "name" => $category);
  $i++;
}

// id, title, category, unused author , unused timestamp to be set on import, text description
$entries[]=array(1, 'prod-test.example.com', 1, 0, 'this prod server was manaullay created');
$entries[]=array(2, 'qa-test.example.com', 1, 0, 'this qa server was manaullay created');
$entries[]=array(3, 'dev-test.example.com', 1, 0, 'this dev server was manaullay created');

echo "Importing entry categories into mongo";
try {
	$mongo = new MongoClient($uri);
	$collection = $mongo->server_inventory->categories;
	$collection->drop();
	$collection->batchInsert($data);
	echo "Entry categories import complete!";
} catch (Exception $e) {
    	echo 'Caught exception on server categories import: ',  $e->getMessage(), "\n";
}
# import from file
#$handle = @fopen("entries.txt", "r");
#$id=46;
#if ($handle) {
#    while (($buffer = fgets($handle, 4096)) !== false) {
#       $entries[]=array($id,'Yo mama', 16,'',strip_tags($buffer)) ;
#    	$id++;
#    }
#    if (!feof($handle)) {
#        echo "Error: unexpected fgets() fail\n";
#    }
#    fclose($handle);
#}

$timestamp=time();
echo "Linking entries to categories ..";
try {
	foreach($entries as $entry) {
  		$catrefcursor = $collection->find(array("_id" => $entry[2]));
		foreach ($catrefcursor as $catref)
		{
  			$entryref[] = MongoDBRef::create("categories", $catref["_id"]);
		}
  		$entrydata[] = array( 	"_id" => $entry[0],"title" => $entry[1],
  						"category" => $entryref,
  						"text" => $entry[4],
						"author" => "Anonymous",
  						"timestamp" => $timestamp
  		);
		unset($entryref);
	}
} catch (Exception $e) {
        echo 'Caught exception linking server categories',  $e->getMessage(), "\n";
}

echo "Importing entries into mongo";
try {
	$collection2= $mongo->server_inventory->servers;
	$collection2->drop();
	$collection2->batchInsert($entrydata);
	echo "Server entries import complete!";
} catch (Exception $e) {
        echo 'Caught exception on server import: ',  $e->getMessage(), "\n";
}

echo "Showing categories:";
$categories2 = $collection->find()->sort(array("_id" => 1));
foreach ($categories2 as $category2) {
	echo "categories:";
    var_dump($category2["name"]);
}


echo "Showing entries:";
$jdump = $collection2->find()->sort(array("_id" => 1));
foreach ($jdump as $j) {
	echo "entries:";
    var_dump($j);
}

?>
