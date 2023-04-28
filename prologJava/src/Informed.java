
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.swing.JButton;
import javax.swing.JLabel;
import org.jpl7.Query;
import org.jpl7.Term;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author menna
 */
public class Informed extends SearchStrategy{

    public Informed(GUI g) {
        super(g);
    }

    // optimal([[[  [*, *, 'O'], ['O', *, *], [*, *, *]  ] ,null,0,0,0]],[3,3],[],G).
    @Override
    String generateInputQuery() {
        String query = "optimal([[["; int rows = (int) gui.getRows().getValue(), cols= (int) gui.getCols().getValue();
        JButton buttons[][] = gui.getBtns();
        for(int i=0;i<rows;i++){
            query+="[";
            for(int j=0;j<cols;j++){
                //char boardItem = 'O'; 
              //  System.out.println( (buttons[i][j].getIcon()==null)?"null":"NOTnull");

                query+=(buttons[i][j].getIcon() == null)?"*":"'O'";
                query+=(j<cols-1)?",":"";
            }
            query+=(i<rows -1)?"],":"]";
        }
         System.out.print(query+"],null,0,0,0]],["+rows+","+cols+"],[],G)");
          return query+"],null,0,0,0]],["+rows+","+cols+"],[],X,G)";
    }
    

    @Override
    String[] generateSolution() {
          // JPanel outputPanel = gui.getPanel();
            //outputPanel.removeAll();
     //   System.out.print(generateInputQuery("uSearch));
     // Query q = new Query("consult('file1.pl'), consult('file2.pl')");
        Query q = new Query("consult('../Prolog implementation/board.pl'),consult('../Prolog implementation/informed.pl')"); 
     //   int rows = (int) Rows.getValue(), cols= (int) Cols.getValue();
       q.hasSolution();
        q= new Query(generateInputQuery());
        Map<String,Term>[] solutions = q.allSolutions(); 
        Set<String> ResultsSet = new HashSet<String>(); 
        for (Map<String, Term> sol :solutions) {
        String s = (sol.get("X").toString()); ResultsSet.add(s); }
       JLabel label =gui.getLabel(); label.setText("Maximum Dominoes: "+solutions[0].get("G"));
       return ResultsSet.toArray(new String[0]);
    }
    
}
