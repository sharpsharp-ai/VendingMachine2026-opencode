#!/bin/bash
cd "/Users/seb/Desktop/Claude Arbeitsfolder/sharp sharp AI/taskforce/compax_csd_mit_opencode/vending_machine_training_start"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
M=src/main/java/de/sharpsharp/vendingmachine
T=src/test/java/de/sharpsharp/vendingmachine
V() { mvn -q --batch-mode verify -Dtest='!RunCucumberTest' 2>&1 | grep -v 'shade\|overlapping\|module-info' | grep -E 'ERROR|WARN|violat|Rule|Tests run:|FAIL|coverage|Coverage' | cut -c1-200 | head -5; echo "exit=${PIPESTATUS[0]}"; }
echo "### Gate 1: Methode mit 25 Zeilen (Checkstyle MethodLength)"
python3 - <<'PY'
import pathlib; p=pathlib.Path("src/main/java/de/sharpsharp/vendingmachine/VendingMachine.java"); s=p.read_text()
body="\n".join(f"        total = total + {i};" for i in range(23))
s=s.rstrip()[:-1]+f"\n    public synchronized int longMethod() {{\n        int total = 0;\n{body}\n        return total;\n    }}\n}}\n"; p.write_text(s)
PY
V; git checkout -q -- src
echo "### Gate 2: VendingMachine importiert Javalin (ArchUnit)"
python3 - <<'PY'
import pathlib; p=pathlib.Path("src/main/java/de/sharpsharp/vendingmachine/VendingMachine.java"); s=p.read_text()
s=s.replace("import java.util.EnumMap;","import io.javalin.Javalin;\nimport java.util.EnumMap;",1)
s=s.replace("    private final Map<Drink, Integer> stock = new EnumMap<>(Drink.class);","    private final Map<Drink, Integer> stock = new EnumMap<>(Drink.class);\n    private Javalin web;",1); p.write_text(s)
PY
V; git checkout -q -- src
echo "### Gate 3: roter Unit-Test (Surefire)"
cat > $T/RotTest.java <<'JAVA'
package de.sharpsharp.vendingmachine;
import org.junit.Test;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
public class RotTest { @Test public void faellt() { assertThat(1, is(2)); } }
JAVA
V; rm $T/RotTest.java
echo "### Gate 4: ungetestete Klasse, Abdeckung unter 80 % (JaCoCo)"
python3 - <<'PY'
import pathlib
lines="\n".join(f"        if (x == {i}) {{ return {i}; }}" for i in range(40))
pathlib.Path("src/main/java/de/sharpsharp/vendingmachine/Untested.java").write_text(f"package de.sharpsharp.vendingmachine;\n\npublic class Untested {{\n    public int a(int x) {{\n{lines}\n        return -1;\n    }}\n}}\n")
PY
sed -i '' 's|<module name="CyclomaticComplexity">|<module name="CyclomaticComplexity"><property name="severity" value="ignore"/>|' config/checkstyle.xml
sed -i '' 's|<property name="max" value="20"/>|<property name="max" value="200"/>|' config/checkstyle.xml
V; rm $M/Untested.java; git checkout -q -- config
echo "### Kontrolle: alles zurückgesetzt, verify grün?"
git status --short; V
echo "### done"
