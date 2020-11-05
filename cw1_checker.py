forbidden = open("forbidden.txt", "r")
forbidden_list = forbidden.readlines()
forbidden_list = [x.replace('\n','') for x in forbidden_list]
forbidden_list = [x.lower() for x in forbidden_list]

filenames = ["01.sql",
    "02.sql",
    "03.sql",
    "04.sql",
    "05.sql",
    "06.sql",
    "07.sql",
    "08.sql",
    "09.sql",
    "10.sql"]

forbidden_words = []

for fn in filenames: 
    print('Checking ' + fn + '...')
    filename = "submissions/" + fn
    cw1 = open(filename, "r")
    cw1_list = cw1.readlines()
    cw1_list = [x.replace('\n','') for x in cw1_list]
    cw1_list = [x.replace('(',' ') for x in cw1_list]
    cw1_list = [x.replace(')',' ') for x in cw1_list]
    cw1_list = [x.replace(';',' ') for x in cw1_list]
    cw1_list = [x.lower() for x in cw1_list]
    tokens = []
    for line in cw1_list:
        for word in line.split(' '):
            if word != '':
                tokens.append(word)

    for word in forbidden_list:
        if word in tokens:
            forbidden_words.append(word)

if len(forbidden_words) == 0:
    print('Congratulations! You have not used any forbidden SQL commands!')
else:
    print(str(len(forbidden_words)) + ' forbidden SQL commands found:')
    for word in forbidden_words:
        print('- ' + word)
