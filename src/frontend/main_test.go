package main

import (
	"context"
	"os"
	"testing"
)

func TestMustMapEnv(t *testing.T) {
	key := "TEST_ENV_KEY"
	value := "test-value"
	os.Setenv(key, value)

	var result string
	mustMapEnv(&result, key)

	if result != value {
		t.Fatalf("expected %q, got %q", value, result)
	}
}

func TestMustConnGRPC_PanicsOnInvalidAddr(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("expected panic due to invalid gRPC address")
		}
	}()
	ctx := context.Background()
	var conn = new(interface{})
	mustConnGRPC(ctx, (**interface{})(conn), "invalid:1234")
}

func TestInitProfilingRunsWithoutCrash(t *testing.T) {
	initProfiling(nil, "frontend", "test")
}
