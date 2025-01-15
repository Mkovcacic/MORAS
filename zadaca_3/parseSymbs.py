def _parse_symbols(self):
    self.r = 0
    # Inicijalizacija predefiniranih oznaka.
    self._init_symbols()

    self._variables = {}
    self._num_vars = 16

    self._iter_lines(self._parse_macro)
    self._iter_lines(self._parse_labels)
    self._iter_lines(self._parse_variables)
    self._iter_lines(self._parse_address)

def _parse_macro(self, line, p, o):
    if line[0] == '$':
           
        # dohvacamo sve poslije $ a prije )
        if '(' in line or ')' in line:
            l = line[1:-1]
            macro = l[:l.index("(")]

            variable = l[ len(macro) + 1:]
            if len(macro) == 0 or len(variable) == 0:
                self._flag = False
                self._line = o
                self._errm = "Invalid macro command"
                return ""
        else:
            if "$END" not in line:
                self._flag = False
                self._line = o
                self._errm = "Invalid macro command"
                return ""
            macro = "END" 
        # provjeravamo koja naredba je u pitanju
        if macro == "MV":
            A = variable[:variable.index(",")]
            B = variable[variable.index(",") + 1:]
            line = f"@{A}\nD=M\n@{B}\nM=D"
        
        elif macro == "SWP":
            A = variable[:variable.index(",")]
            B = variable[variable.index(",") + 1:]
            line = f"@{B}\nD=M\n@{A}\nM=M+D\n"
            line += f"D=M\n@{B}\nM=D-M\nD=M\n@{A}\nM=M-D"

        elif macro == "ADD":
            A = variable[:variable.index(",")]
            B = variable[variable.index(",") + 1:]
            D = B[B.index(",") + 1:]
            B = B[:B.index(",") ]
            line = f"@{A}\nD=M\n@{B}\nD=D+M\n@"
            line += f"{D}\nM=D"

        elif macro == "WHILE":
            self.r += 1
            A = variable
            line = f"(WHILE{str(self.r)}_START)\n@{A}\nD=M\n@WHILE{str(self.r)}_END\nD;JEQ"
        
        elif macro == "END":
            line = f"@WHILE{str(self.r)}_START\n0;JMP\n(WHILE{str(self.r)}_END)"
            self.r -= 1
        
        else:
            self._flag = False
            self._line = o
            self._errm = "No matching macro command"
    return line



# Svaka oznaka mora biti sadrzana unutar oblih zagrada. Npr. "(LOOP)". Svaka
# oznaka koju procitamo treba zapamtiti broj linije u kojoj se nalazi i biti
# izbrisana iz nje. Koristimo dictionary _labels.

def _parse_labels(self, line, p, o):
    if line[0] == '(':
        # dohvatimo oznaku izemdju zagrada ( )
        label = line[1:-1]
        if len(label) == 0:
            self._flag = False
            self._line = o
            self._errm = "Invalid label"
        else:
            self._labels[label] = str(p)
        
        return ""
    else:
        return line

# Svaki poziv na varijablu ili oznaku je oblika "@NAZIV", gdje naziv nije broj.
# Prvo provjeriti oznake ("_labels"), a potom varijable ("_vars"). Varijablama
# dodjeljujemo memorijske adrese pocevsi od 16. Ova funkcija nikad ne vraca
# prazan string!
def _parse_variables(self, line, p, o):
    if line[0] != '@':
        return line
    
    l = line[1:]

    if l.isdigit():
        return line
    
    if l in self._labels:
        return "@" + self._labels[l]
    
    if l not in self._variables:
        self._variables[l] = str(self._num_vars)
        self._num_vars += 1

    return "@" + self._variables[l]

def _parse_address(self, line, p, o):
    if line[0] != '@':
        return line

    l = line[1:]

    if (l.isdigit() and int(l) > 32767):
        self._flag = False
        self._line = o
        self._errm = "Wrong memory address"

    return line

# Inicijalizacija predefiniranih oznaka.
def _init_symbols(self):
    self._labels = {
        "SCREEN" : "16384",
        "KBD" : "24576",
        "SP" : "0",
        "LCL" : "1",
        "ARG" : "2",
        "THIS" : "3",
        "THAT" : "4"
    }
    
    for i in range(0, 16):
        self._labels["R" + str(i)] = str(i)
