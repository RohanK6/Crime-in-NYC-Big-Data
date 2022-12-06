
import java.io.IOException;
import java.util.Arrays;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CleanMapper
        extends Mapper<Object, Text, Text, Text>{


    @Override
    public void map(Object key, Text value, Context context)
            throws IOException, InterruptedException {

        String line = value.toString();
        String[] fields = line.split(",");

        //Collumns to keep
        int[] indicies = {0,1,3,7,8,9,11,12,14,15,16,17};

        //Copy indicies into new ar
        String[] cleanedField = Arrays.stream(indicies).mapToObj(i -> fields[i]).toArray(String[]::new);

        //we keep null values so we have more data when doing analysis on columns without nulls.
        Text cleanedRecord = new Text(String.join(",", cleanedField));

        context.write(cleanedRecord, new Text(""));

    }
}
