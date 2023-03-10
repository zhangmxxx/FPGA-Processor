#include "built-in-app.h"


static int fib[50];
/* fib*/
void fib_help() {
  printf("Invalid command format, Type fib (number).\n"); 
}

int fib_cal(int n) {
  if (n > 48) {
    printf("Overflow for int\n");
    return -1;
  }

  fib[0] = 0;
  fib[1] = 1;
  for (int i = 2; i <= n; ++i) {
    fib[i] = fib[i - 1] + fib[i - 2];
  }
  return fib[n];
}

/* calculator */
enum {
    TK_HEX_NUM, TK_DEC_NUM,
    TK_L_PARE, TK_R_PARE,
    TK_ADD, TK_SUB, TK_MUL, TK_DIV,
    TK_ALL_END
};

#define EVAL_ERROR(fmt, ...) printf(ANSI_FMT("[expr.c:%d %s] " fmt, ANSI_FG_RED), __LINE__, __func__ ,## __VA_ARGS__)


static inline int OP_PRI(unsigned int TK_TYPE) {
    switch (TK_TYPE)
    {
    case TK_ADD: case TK_SUB:
        return 1;
    case TK_MUL: case TK_DIV:
        return 2;
    default:
        return 0;
    }
}

typedef struct token {
    int type;
    char* str;
} Token;

#define TK_BF_L 32

static Token tokens[TK_BF_L];
static int nr_token = 0;

static bool make_token(char* line) {
    nr_token = 0;

    int len = strlen(line);

    for (int i = 0; i < len;) {
        switch (line[i]) {
        case ' ':
            line[i] = '\n';
            i++;
            break;
        case '(':
            tokens[nr_token] = (Token){ .type = TK_L_PARE, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        case ')':
            tokens[nr_token] = (Token){ .type = TK_R_PARE, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        case '+':
            tokens[nr_token] = (Token){ .type = TK_ADD, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        case '-':
            tokens[nr_token] = (Token){ .type = TK_SUB, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        case '*':
            tokens[nr_token] = (Token){ .type = TK_MUL, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        case '/':
            tokens[nr_token] = (Token){ .type = TK_DIV, .str = NULL };
            line[i] = '\0';
            nr_token++;
            i++;
            break;
        default:
            if (line[i] == '0' && line[i + 1] == 'x') {
                tokens[nr_token] = (Token){ .type = TK_HEX_NUM, .str = line + i };
                nr_token++;
                i += 2;
                while ((line[i] >= '0' && line[i] <= '9') || (line[i] >= 'a' && line[i] <= 'f'))i++;
            }
            else if (line[i] >= '0' && line[i] <= '9') {
                tokens[nr_token] = (Token){ .type = TK_DEC_NUM, .str = line + i };
                nr_token++;
                while (line[i] >= '0' && line[i] <= '9')i++;
            }
            else {
                printf("Unknown token!\n");
                return false;
            }
            break;
        }
    }

    tokens[nr_token++].type = TK_ALL_END;

    return true;
}


static int tokens_index;                                           
#define NOW_TK tokens[tokens_index]                            
#define POP_TK() tokens_index++                                      
static int get_atom(bool* success);                                
static int get_expr(int op_pri_min, bool* success);             

static int get_atom(bool* success) {
    int res;
    switch (NOW_TK.type)
    {
    case TK_DEC_NUM:   
        res = atoi(NOW_TK.str);
        POP_TK();        
        break;
    case TK_HEX_NUM:   
        res = htoi(NOW_TK.str);
        POP_TK();
        break;
    case TK_ADD:      
        POP_TK();
        res = get_atom(success);
        break;
    case TK_SUB:      
        POP_TK();
        res = -get_atom(success);
        break;
    case TK_L_PARE:  
        POP_TK();  
        res = get_expr(0, success);
        if (NOW_TK.type != TK_R_PARE) {  
            //EVAL_ERROR("Right parenthesis doesn't match.\n");
            printf("Right parenthesis doesn't match.\n");
            *success = false;
            return 0;
        }
        POP_TK();  
        break;
    default:
        *success = false;
        //EVAL_ERROR("Unexpected begin token type: %d\n", NOW_TK.type);
        printf("Unexpected begin token type: %d\n", NOW_TK.type);
        return 0;
    }
    return res;
}

#define IS_END_TOKEN(type) (type == TK_R_PARE || type == TK_ALL_END)   
#define IS_OP_TOKEN(type) (type >= TK_ADD && type <= TK_DIV)            

static int get_expr(int op_pri_min, bool* success) {
    int res = get_atom(success); 
    if (!*success) {
        return 0;
    }
    while (true) {
        unsigned int op_type = NOW_TK.type; 
        if (IS_END_TOKEN(op_type))break; 
        if (!IS_OP_TOKEN(op_type)) {
            //EVAL_ERROR("Unexpect operator token type: %d.\n", NOW_TK.type);
            printf("Unexpect operator token type: %d.\n", NOW_TK.type);
            *success = false;
            return 0;
        }
        if (OP_PRI(op_type) < op_pri_min)break; 
        POP_TK(); 
        int src = get_expr(OP_PRI(op_type) + 1, success); 
        switch (op_type) 
        {
        case TK_ADD: res = res + src;  break;
        case TK_SUB: res = res - src;  break;
        case TK_MUL: res = res * src;  break;
        case TK_DIV:
            if (!src) {
                //EVAL_ERROR("Devided by zero error!\n");
                printf("Devided by zero error!\n");
                *success = false;
                return 0;
            }
            res = (uint32_t)res / (uint32_t) src;
            break;
        }
    }

    return res;
}

int expr(char* e, bool* success) {
    if (!make_token(e)) {
        *success = false;
        return 0;
    }
    *success = true;
    tokens_index = 0;
    int res = get_expr(0, success);
    if (NOW_TK.type != TK_ALL_END) {
        *success = false;
        //EVAL_ERROR("Unexpected end token type: %d\n", NOW_TK.type);
        printf("Unexpected end token type: %d\n", NOW_TK.type);
    }
    if (!*success) return 0;
    return res;
}
