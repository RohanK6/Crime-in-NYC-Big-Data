import java.io.IOException;
import java.util.Arrays;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CleanMapper extends Mapper<Object, Text, Text, Text> {
    private final Text defaultValue  = new Text("");

    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
	String line = value.toString();
	String[] fields = line.split(",");

	// An indices array to specify what columns of the fields we want to keep
	int[] indices = {0, 1, 6, 9, 10, 14, 15};
	
 	// Copy those specific indices into a new array
	String[] cleanedFields = Arrays.stream(indices).mapToObj(i -> fields[i]).toArray(String[]::new);
	 				
	 // Join all of the new array elements into one single Text() element to write
	 Text cleanedRecord = new Text(String.join(",", cleanedFields));
	 
         if (!cleanedFields[3].equals("AGE_GROUP")) {
	     context.write(cleanedRecord, defaultValue);
         }
    }
}
	
