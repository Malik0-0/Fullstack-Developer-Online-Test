<?php

class Test
{
    function mergeSortArray($a, $b) {
        $result = array();
        $resultIndex = 0;
        
        for ($i = 0; $i < count($a); $i++) {
            $result[$resultIndex] = $a[$i];
            $resultIndex++;
        }
        
        for ($i = 0; $i < count($b); $i++) {
            $result[$resultIndex] = $b[$i];
            $resultIndex++;
        }
        
        $n = count($result);
        for ($i = 0; $i < $n - 1; $i++) {
            for ($j = 0; $j < $n - $i - 1; $j++) {
                if ($result[$j] > $result[$j + 1]) {
                    $temp = $result[$j];
                    $result[$j] = $result[$j + 1];
                    $result[$j + 1] = $temp;
                }
            }
        }
        
        return $result;
    }
    
    function getMissingData($arr) {
        if (count($arr) == 0) {
            return array();
        }
        
        $min = $arr[0];
        $max = $arr[count($arr) - 1];
        $missing = array();
        $missingIndex = 0;
        
        for ($num = $min + 1; $num < $max; $num++) {
            $found = false;
            
            for ($i = 0; $i < count($arr); $i++) {
                if ($arr[$i] == $num) {
                    $found = true;
                    break;
                }
            }
            
            if (!$found) {
                $missing[$missingIndex] = $num;
                $missingIndex++;
            }
        }
        
        return $missing;
    }
    
    function insertMissingData($arr, $missingData) {
        $result = array();
        $resultIndex = 0;
        
        for ($i = 0; $i < count($arr); $i++) {
            $result[$resultIndex] = $arr[$i];
            $resultIndex++;
        }
        
        for ($i = 0; $i < count($missingData); $i++) {
            $result[$resultIndex] = $missingData[$i];
            $resultIndex++;
        }
        
        $n = count($result);
        for ($i = 0; $i < $n - 1; $i++) {
            for ($j = 0; $j < $n - $i - 1; $j++) {
                if ($result[$j] > $result[$j + 1]) {
                    $temp = $result[$j];
                    $result[$j] = $result[$j + 1];
                    $result[$j + 1] = $temp;
                }
            }
        }
        
        return $result;
    }
    
    public function main() {
        $a = array(11, 36, 65, 135, 98);
        $b = array();
        $b[0] = 81;
        $b[1] = 23;
        $b[2] = 50;
        $b[3] = 155;
        
        echo "Array a: ";
        print_r($a);
        echo "Array b: ";
        print_r($b);
        
        $c = $this->mergeSortArray($a, $b);
        echo "\nSetelah merge dan sort: ";
        print_r($c);
        
        $i = $this->getMissingData($c);
        echo "\nMissing data: ";
        print_r($i);
        
        $d = $this->insertMissingData($c, $i);
        echo "\nHasil akhir (dengan missing data): ";
        print_r($d);
    }
}

$t = new Test();
$t->main();
?>
