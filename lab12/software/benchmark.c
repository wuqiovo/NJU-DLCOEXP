#include <stdint.h>

#include "sys.h"
#include "terminal.h"
#include "expression.h"
#include "benchmark.h"

// 需要是2的模
#define BENCHMARK_DATA_SIZE 64u

static volatile uint32_t benchmark_sink;
static volatile uint32_t benchmark_data[BENCHMARK_DATA_SIZE];

static uint32_t timer_read_overhead(void)
{
    uint32_t best = 0xffffffffu;
    uint32_t i;

    for (i = 0; i < 8u; ++i) {
        uint32_t start = timer_cycles();
        uint32_t end = timer_cycles();
        uint32_t elapsed = end - start;

        if (elapsed < best) {
            best = elapsed;
        }
    }

    return best;
}

static uint32_t corrected_cycles(uint32_t start,
                                 uint32_t end,
                                 uint32_t overhead)
{
    uint32_t elapsed = end - start;

    if (elapsed > overhead) {
        return elapsed - overhead;
    }

    return 0;
}

static uint32_t alu_kernel(uint32_t rounds)
{
    uint32_t i;
    uint32_t value = 0x12345678u;

    for (i = 0; i < rounds; ++i) {
        value += i + 0x9e3779b9u;
        value ^= value << 7;
        value ^= value >> 9;
        value += value << 3;
    }

    return value;
}

static void memory_initialize(void)
{
    uint32_t i;

    for (i = 0; i < BENCHMARK_DATA_SIZE; ++i) {
        benchmark_data[i] =
            0x10203040u + i * 0x01010101u;
    }
}

static uint32_t memory_kernel(uint32_t rounds)
{
    uint32_t i;
    uint32_t value = 0x13579bdfu;

    for (i = 0; i < rounds; ++i) {
        uint32_t index =
            i & (BENCHMARK_DATA_SIZE - 1u);

        value += benchmark_data[index];
        benchmark_data[index] = value ^ i;
    }

    return value;
}

static uint32_t expression_kernel(uint32_t rounds)
{
    static const char expression[] =
        "12 + 3 * (4 - 1) - 20 / 5";

    uint32_t i;
    uint32_t checksum = 0;

    for (i = 0; i < rounds; ++i) {
        ExpressionResult result =
            expression_evaluate(expression);

        checksum =
            (checksum << 5) - checksum
            + (uint32_t)result.value
            + (uint32_t)result.error;
    }

    return checksum;
}

static void print_measurement(const char *name,
                              uint32_t rounds,
                              uint32_t cycles,
                              uint32_t checksum)
{
    terminal_puts(name);
    terminal_puts(": ");
    terminal_put_uint(cycles);
    terminal_puts(" cycles, ");
    terminal_put_uint(cycles / rounds);
    terminal_puts(" cycles/round, checksum=");
    terminal_put_uint(checksum);
    terminal_putchar('\n');
}

void benchmark_run(uint32_t rounds)
{
    uint32_t overhead;
    uint32_t start;
    uint32_t end;
    uint32_t alu_cycles;
    uint32_t memory_cycles;
    uint32_t expression_cycles;
    uint32_t alu_result;
    uint32_t memory_result;
    uint32_t expression_result;

    if (rounds == 0u) {
        terminal_puts("Benchmark rounds must be nonzero.\n");
        return;
    }

    benchmark_sink = alu_kernel(8u);
    memory_initialize();
    benchmark_sink = memory_kernel(8u);
    benchmark_sink = expression_kernel(1u);

    overhead = timer_read_overhead();

    start = timer_cycles();
    alu_result = alu_kernel(rounds);
    end = timer_cycles();
    alu_cycles = corrected_cycles(start, end, overhead);

    memory_initialize();
    start = timer_cycles();
    memory_result = memory_kernel(rounds);
    end = timer_cycles();
    memory_cycles = corrected_cycles(start, end, overhead);

    start = timer_cycles();
    expression_result = expression_kernel(rounds);
    end = timer_cycles();
    expression_cycles = corrected_cycles(start, end, overhead);

    benchmark_sink =
        alu_result ^ memory_result ^ expression_result;

    terminal_puts("Timer overhead: ");
    terminal_put_uint(overhead);
    terminal_puts(" cycles\n");

    print_measurement("ALU", rounds,
                      alu_cycles, alu_result);
    print_measurement("Memory", rounds,
                      memory_cycles, memory_result);
    print_measurement("Expression", rounds,
                      expression_cycles, expression_result);
}