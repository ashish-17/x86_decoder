#include <stdio.h>

int main() {
    int n = 0;
    scanf("%d", &n);

    int i = 0, factorial = 1;
    for (i = 2; i <= n; ++i) {
        factorial *= i;
    }

    printf("%d", factorial);

    return 0;
}
