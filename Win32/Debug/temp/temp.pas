
program StudentInfo;

var
  studentName: string;
  studentID: string;
  studentGrade: integer;

begin
  writeln('Enter student name:');
  readln(studentName);

  writeln('Enter student ID:');
  readln(studentID);

  writeln('Enter student grade:');
  readln(studentGrade);

  writeln('--- Student Information ---');
  writeln('Name: ', studentName);
  writeln('ID: ', studentID);
  writeln('Grade: ', studentGrade);
end.
