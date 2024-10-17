package lyc.compiler.files;

import lyc.compiler.simbolsTable.SimbolTable;

import java.io.FileWriter;
import java.io.IOException;

public class SymbolTableGenerator implements FileGenerator{

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        SimbolTable simbolTable = SimbolTable.getSingletonInstance();
        fileWriter.write(simbolTable.toString());
    }
}