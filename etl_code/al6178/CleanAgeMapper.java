
import java.io.IOException;
import java.util.Arrays;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CleanAgeMapper
        extends Mapper<Object, Text, Text, Text>{


    @Override
    public void map(Object key, Text value, Context context)
            throws IOException, InterruptedException {

        String line = value.toString();
        String[] fields = line.split(",");

        //Age Groups to Keep
        String[] groups_keep = {"18-24", "25-44", "45-64", "65+", "<18", "UNKOWN"};

        boolean correct_field = Arrays.asList(groups_keep).contains(fields[4]) && Arrays.asList(groups_keep).contains(fields[6]);
        
        if(correct_field){
            Text cleanedRecord = new Text(String.join(",", fields));
            context.write(cleanedRecord, new Text(""));
        }
    }
}
